package com.bupt.videometadata.collections.value;

import com.bupt.videometadata.collections.VideoMetaDataType;
import lombok.Data;

import java.io.IOException;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * @author Che Jin <jotline@github>
 */
//imgarray类型的type的值类型
@Data
public class VideoMetaDataImgArray extends VideoMetaDataValue implements Serializable {

    protected void writeObject(java.io.ObjectOutputStream s) throws IOException {
        super.writeObject(s);
        s.defaultWriteObject();
        s.writeObject(array);
    }

    @SuppressWarnings("unchecked")
    protected void readObject(java.io.ObjectInputStream s)
            throws IOException, ClassNotFoundException {
        super.readObject(s);
        s.defaultReadObject();
        reinitialize();
        array = (List<VideoMetaDataImg>) s.readObject();

    }

    private void reinitialize() {
        array = null;
    }


    static {
        metaDataType = VideoMetaDataType.IMG_ARRAY;
    }

    private List<VideoMetaDataImg> array = new ArrayList<VideoMetaDataImg>();

    public String toString() {
        StringBuilder result = new StringBuilder();
        result.append(super.toString());
        array.stream().forEach(item ->
                result.append(item.toString()));
        return result.toString();
    }
}
