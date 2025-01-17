/*
 This file is part of Subsonic.

 Subsonic is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 Subsonic is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with Subsonic.  If not, see <http://www.gnu.org/licenses/>.

 Copyright 2009 (C) Sindre Mehus
 */
package net.sourceforge.subsonic.domain;

import java.io.File;

import net.sourceforge.subsonic.util.BoundedList;

/**
 * Status for a single transfer (stream, download or upload).
 *
 * @author Sindre Mehus
 */
public class TransferStatus {

    private static final int HISTORY_LENGTH = 200;
    private static final long SAMPLE_INTERVAL_MILLIS = 5000;

    private Player player;
    private MediaFile file;
    private long bytesTransfered;
    private long bytesSkipped;
    private long bytesTotal;
    private final SampleHistory history = new SampleHistory();
    private boolean terminated;
    private boolean active = true;

    /**
     * Return the number of bytes transferred.
     *
     * @return The number of bytes transferred.
     */
    public synchronized long getBytesTransfered() {
        return bytesTransfered;
    }

    /**
     * Adds the given byte count to the total number of bytes transferred.
     *
     * @param byteCount The byte count.
     */
    public synchronized void addBytesTransfered(long byteCount) {
        setBytesTransfered(bytesTransfered + byteCount);
    }

    /**
     * Sets the number of bytes transferred.
     *
     * @param bytesTransfered The number of bytes transferred.
     */
    public synchronized void setBytesTransfered(long bytesTransfered) {
        this.bytesTransfered = bytesTransfered;
        createSample(bytesTransfered, false);
    }

    private void createSample(long bytesTransfered, boolean force) {
        long now = System.currentTimeMillis();

        if (history.isEmpty()) {
            history.add(new Sample(bytesTransfered, now));
        } else {
            Sample lastSample = history.getLast();
            if (force || now - lastSample.getTimestamp() > TransferStatus.SAMPLE_INTERVAL_MILLIS) {
                history.add(new Sample(bytesTransfered, now));
            }
        }
    }

    /**
     * Returns the number of milliseconds since the transfer status was last updated.
     *
     * @return Number of milliseconds, or <code>0</code> if never updated.
     */
    public synchronized long getMillisSinceLastUpdate() {
        if (history.isEmpty()) {
            return 0L;
        }
        return System.currentTimeMillis() - history.getLast().timestamp;
    }

    /**
     * Returns the total number of bytes, or 0 if unknown.
     *
     * @return The total number of bytes, or 0 if unknown.
     */
    public long getBytesTotal() {
        return bytesTotal;
    }

    /**
     * Sets the total number of bytes, or 0 if unknown.
     *
     * @param bytesTotal The total number of bytes, or 0 if unknown.
     */
    public void setBytesTotal(long bytesTotal) {
        this.bytesTotal = bytesTotal;
    }

    /**
     * Returns the number of bytes that has been skipped (for instance when
     * resuming downloads).
     *
     * @return The number of skipped bytes.
     */
    public synchronized long getBytesSkipped() {
        return bytesSkipped;
    }

    /**
     * Sets the number of bytes that has been skipped (for instance when
     * resuming downloads).
     *
     * @param bytesSkipped The number of skipped bytes.
     */
    public synchronized void setBytesSkipped(long bytesSkipped) {
        this.bytesSkipped = bytesSkipped;
    }


    /**
     * Adds the given byte count to the total number of bytes skipped.
     *
     * @param byteCount The byte count.
     */
    public synchronized void addBytesSkipped(long byteCount) {
        bytesSkipped += byteCount;
    }

    /**
     * Returns the file that is currently being transferred.
     *
     * @return The file that is currently being transferred.
     */
    public synchronized MediaFile getFile() {
        return file;
    }

    /**
     * Sets the file that is currently being transferred.
     *
     * @param file The file that is currently being transferred.
     */
    public synchronized void setFile(MediaFile file) {
        this.file = file;
    }

    /**
     * Returns the remote player for the stream.
     *
     * @return The remote player for the stream.
     */
    public synchronized Player getPlayer() {
        return player;
    }

    /**
     * Sets the remote player for the stream.
     *
     * @param player The remote player for the stream.
     */
    public synchronized void setPlayer(Player player) {
        this.player = player;
    }

    /**
     * Returns a history of samples for the stream
     *
     * @return A (copy of) the history list of samples.
     */
    public synchronized SampleHistory getHistory() {
        return new SampleHistory(history);
    }

    /**
     * Returns the history length in milliseconds.
     *
     * @return The history length in milliseconds.
     */
    public long getHistoryLengthMillis() {
        return TransferStatus.SAMPLE_INTERVAL_MILLIS * (TransferStatus.HISTORY_LENGTH - 1);
    }

    /**
     * Indicate that the stream should be terminated.
     */
    public void terminate() {
        terminated = true;
    }

    /**
     * Returns whether this stream has been terminated.
     * Not that the <em>terminated status</em> is cleared by this method.
     *
     * @return Whether this stream has been terminated.
     */
    public boolean terminated() {
        boolean result = terminated;
        terminated = false;
        return result;
    }

    /**
     * Returns whether this transfer is active, i.e., if the connection is still established.
     *
     * @return Whether this transfer is active.
     */
    public boolean isActive() {
        return active;
    }

    /**
     * Sets whether this transfer is active, i.e., if the connection is still established.
     *
     * @param active Whether this transfer is active.
     */
    public void setActive(boolean active) {
        this.active = active;

        if (active) {
            setBytesSkipped(0L);
            setBytesTotal(0L);
            setBytesTransfered(0L);
        } else {
            createSample(getBytesTransfered(), true);
        }
    }

    /**
     * A sample containing a timestamp and the number of bytes transferred up to that point in time.
     */
    public static class Sample {
        private long bytesTransfered;
        private long timestamp;

        /**
         * Creates a new sample.
         *
         * @param bytesTransfered The total number of bytes transferred.
         * @param timestamp       A point in time, in milliseconds.
         */
        public Sample(long bytesTransfered, long timestamp) {
            this.bytesTransfered = bytesTransfered;
            this.timestamp = timestamp;
        }

        /**
         * Returns the number of bytes transferred.
         *
         * @return The number of bytes transferred.
         */
        public long getBytesTransfered() {
            return bytesTransfered;
        }

        /**
         * Returns the timestamp of the sample.
         *
         * @return The timestamp in milliseconds.
         */
        public long getTimestamp() {
            return timestamp;
        }
    }

    @Override
    public String toString() {
        StringBuilder builder = new StringBuilder();
        builder.append("TransferStatus-").append(hashCode()).append(" [player: ").append(player.getId()).append(", file: ");
        builder.append(file).append(", terminated: ").append(terminated).append(", active: ").append(active).append("]");
        return builder.toString();
    }

    /**
     * Contains recent history of samples.
     */
    public static class SampleHistory extends BoundedList<Sample> {

        public SampleHistory() {
            super(HISTORY_LENGTH);
        }

        public SampleHistory(SampleHistory other) {
            super(HISTORY_LENGTH);
            addAll(other);
        }
    }
}
