const API = "https://api.shedma.com";

async function checkHealth() {
    const status = document.getElementById("status");

    try {
        const response = await fetch(`${API}/health`);

        if (!response.ok) {
            throw new Error(`Health check failed: ${response.status}`);
        }

        status.textContent = "Backend Online";
        status.className = "online";
    } catch (error) {
        console.error("Health check error:", error);
        status.textContent = "Backend Offline";
        status.className = "offline";
    }
}

async function loadEvents() {
    const table = document.getElementById("eventsTable");

    try {
        const response = await fetch(`${API}/events`);

        if (!response.ok) {
            throw new Error(`Could not load events: ${response.status}`);
        }

        const events = await response.json();
        table.innerHTML = "";

        events.forEach((event) => {
            const row = document.createElement("tr");

            [
                event.service,
                event.event,
                event.severity,
                event.description,
                event.created_at
            ].forEach((value) => {
                const cell = document.createElement("td");
                cell.textContent = value ?? "";
                row.appendChild(cell);
            });

            table.appendChild(row);
        });
    } catch (error) {
        console.error("Load events error:", error);

        table.innerHTML = `
            <tr>
                <td colspan="5">Unable to load events.</td>
            </tr>
        `;
    }
}

document
    .getElementById("eventForm")
    .addEventListener("submit", async (event) => {
        event.preventDefault();

        const form = event.currentTarget;
        const submitButton = form.querySelector('button[type="submit"]');

        const payload = {
            service: document.getElementById("service").value.trim(),
            event: document.getElementById("event").value.trim(),
            severity: document.getElementById("severity").value,
            description: document.getElementById("description").value.trim()
        };

        try {
            if (submitButton) {
                submitButton.disabled = true;
            }

            const response = await fetch(`${API}/events`, {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify(payload)
            });

            if (!response.ok) {
                throw new Error(`Event submission failed: ${response.status}`);
            }

            form.reset();
            await loadEvents();
        } catch (error) {
            console.error("Submit event error:", error);
            alert("The event could not be submitted.");
        } finally {
            if (submitButton) {
                submitButton.disabled = false;
            }
        }
    });

checkHealth();
loadEvents();