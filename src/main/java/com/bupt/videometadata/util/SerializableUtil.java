package com.bupt.videometadata.util;

import java.io.*;

/**
 * @author Che Jin <jotline@github>
 */
public class SerializableUtil {
    //这个类专门用来做一些序列化的支持，比如说把一个类变成一个byte数组，从一个byte数组读入一个类之类的

    public static byte[] serializeObject(Object o) throws IOException {
        byte[] result = null;
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        ObjectOutputStream objectOutputStream = new ObjectOutputStream(byteArrayOutputStream);
        result = byteArrayOutputStream.toByteArray();
        return result;
    }

    public static Object deserializeBytes(byte[] bytes) throws IOException, ClassNotFoundException {
        ByteArrayInputStream bais = new ByteArrayInputStream(bytes);
        ObjectInputStream ois = new ObjectInputStream(bais);
        return ois.readObject();
    }


}
