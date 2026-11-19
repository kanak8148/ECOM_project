package in.co.rays.ctl;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

import in.co.rays.model.BaseModel;
import in.co.rays.model.ProductModel;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ImageCtl")
public class ImageCtl extends BaseCtl {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");

        if (name == null || name.isEmpty()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // path traversal se bachne ke liye sirf file ka naam lete hain
        name = new File(name).getName();

        File file = new File(ProductModel.IMAGE_DIR, name);

        if (!file.exists() || !file.isFile()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String type = Files.probeContentType(file.toPath());
        response.setContentType(type != null ? type : "application/octet-stream");
        response.setContentLengthLong(file.length());

        Files.copy(file.toPath(), response.getOutputStream());
    }

    @Override
    public BaseModel getModel() {
        return null;
    }

    @Override
    public String getView() {
        return null;
    }
}