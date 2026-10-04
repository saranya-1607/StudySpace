```vue
<template>
  <!-- Navbar -->
  <v-app-bar color="white" elevation="0" class="modern-navbar">
    <v-container>
      <v-row align="center" no-gutters class="d-flex align-center">

        <!-- Logo and Title -->
        <v-col class="d-flex align-center">
          <v-icon
            class="logo-icon mr-2"
            style="
              font-family: 'Poppins', sans-serif;
              font-size: 24px;
            "
          >
            mdi-school
          </v-icon>

          <v-toolbar-title
            class="title"
            style="
              font-family: 'Poppins', sans-serif;
              font-size: 24px;
              cursor: pointer;
            "
            @click="goToLanding"
          >
            StudySpace
          </v-toolbar-title>
        </v-col>

        <!-- Desktop Navigation Links -->
        <v-col class="d-none d-md-flex justify-end align-center">

          <!-- Home -->
          <v-btn
            text
            to="/home"
            class="nav-btn"
            :class="{ 'active-link': $route.path === '/home' }"
            style="
              font-family: 'Poppins', sans-serif;
              font-size: 16px;
            "
          >
            <v-icon class="nav-icon">mdi-home</v-icon>
            Home
          </v-btn>

          <!-- Tools Menu -->
          <v-menu open-on-hover>
            <template v-slot:activator="{ props }">
              <v-btn
                text
                class="nav-btn"
                v-bind="props"
                style="
                  font-family: 'Poppins', sans-serif;
                  font-size: 16px;
                "
              >
                <v-icon class="nav-icon">mdi-tools</v-icon>
                Tools
                <v-icon>mdi-chevron-down</v-icon>
              </v-btn>
            </template>

            <v-list>

              <v-list-item to="/materials">
                <v-list-item-title>
                  <v-icon class="mr-2">
                    mdi-book-open-variant
                  </v-icon>
                  Study Materials
                </v-list-item-title>
              </v-list-item>

              <v-list-item to="/quizzes">
                <v-list-item-title>
                  <v-icon class="mr-2">
                    mdi-file-question
                  </v-icon>
                  Quizzes
                </v-list-item-title>
              </v-list-item>

              <v-list-item to="/progress">
                <v-list-item-title>
                  <v-icon class="mr-2">
                    mdi-chart-line
                  </v-icon>
                  Progress Tracker
                </v-list-item-title>
              </v-list-item>

              <v-list-item to="/goals">
                <v-list-item-title>
                  <v-icon class="mr-2">
                    mdi-target
                  </v-icon>
                  Goals
                </v-list-item-title>
              </v-list-item>

              <v-list-item to="/planner">
                <v-list-item-title>
                  <v-icon class="mr-2">
                    mdi-calendar
                  </v-icon>
                  Study Planner
                </v-list-item-title>
              </v-list-item>

            </v-list>
          </v-menu>

          <!-- Resources -->
          <v-btn
            text
            to="/resources"
            class="nav-btn"
            :class="{ 'active-link': $route.path === '/resources' }"
            style="
              font-family: 'Poppins', sans-serif;
              font-size: 16px;
            "
          >
            <v-icon class="nav-icon">
              mdi-link-variant
            </v-icon>
            Resources
          </v-btn>

          <!-- Profile -->
          <v-btn
            text
            to="/profile"
            class="nav-btn"
            :class="{ 'active-link': $route.path === '/profile' }"
            style="
              font-family: 'Poppins', sans-serif;
              font-size: 16px;
            "
          >
            <v-icon class="nav-icon">
              mdi-account
            </v-icon>
            Profile
          </v-btn>

          <!-- Register -->
          <v-btn
            text
            to="/register"
            class="nav-btn"
            :class="{ 'active-link': $route.path === '/register' }"
            style="
              font-family: 'Poppins', sans-serif;
              font-size: 16px;
            "
          >
            <v-icon class="nav-icon">
              mdi-account-plus
            </v-icon>
            Register
          </v-btn>

          <!-- Login -->
          <v-btn
            v-if="!isAuthenticated"
            text
            to="/login"
            class="nav-btn"
            :class="{ 'active-link': $route.path === '/login' }"
            style="
              font-family: 'Poppins', sans-serif;
              font-size: 16px;
            "
          >
            <v-icon class="nav-icon">
              mdi-login
            </v-icon>
            Login
          </v-btn>

          <!-- Logout -->
          <v-btn
            v-if="isAuthenticated"
            text
            @click="logoutAndCloseDrawer"
            class="nav-btn logout-btn"
            style="
              font-family: 'Poppins', sans-serif;
              font-size: 16px;
            "
          >
            <v-icon class="nav-icon">
              mdi-logout
            </v-icon>
            Logout
          </v-btn>

        </v-col>

        <!-- Mobile Menu Icon -->
        <v-col class="d-flex d-md-none justify-end">
          <v-app-bar-nav-icon
            class="mobile-menu-icon"
            @click="drawer = !drawer"
          />
        </v-col>

      </v-row>
    </v-container>
  </v-app-bar>

  <!-- Mobile Drawer -->
  <v-navigation-drawer
    v-model="drawer"
    temporary
    fixed
    left
    width="280"
    overlay
    class="indigo darken-3"
  >
    <v-list dense class="mobile-drawer-list">

      <!-- Home -->
      <v-list-item
        to="/home"
        @click="closeDrawer"
        class="mobile-nav-item"
      >
        <v-list-item-icon>
          <v-icon class="mobile-nav-icon">
            mdi-home
          </v-icon>
        </v-list-item-icon>

        <v-list-item-content
          style="
            font-family: 'Poppins', sans-serif;
            font-size: 16px;
          "
        >
          Home
        </v-list-item-content>
      </v-list-item>

      <!-- Study Tools -->
      <v-list-group value="tools">

        <template v-slot:activator="{ props }">
          <v-list-item v-bind="props">

            <v-list-item-icon>
              <v-icon class="mobile-nav-icon">
                mdi-tools
              </v-icon>
            </v-list-item-icon>

            <v-list-item-content
              style="
                font-family: 'Poppins', sans-serif;
                font-size: 16px;
              "
            >
              Study Tools
            </v-list-item-content>

          </v-list-item>
        </template>

        <!-- Study Materials -->
        <v-list-item
          to="/materials"
          @click="closeDrawer"
        >
          <v-list-item-icon>
            <v-icon class="mobile-nav-icon">
              mdi-book-open-variant
            </v-icon>
          </v-list-item-icon>

          <v-list-item-content>
            Study Materials
          </v-list-item-content>
        </v-list-item>

        <!-- Quizzes -->
        <v-list-item
          to="/quizzes"
          @click="closeDrawer"
        >
          <v-list-item-icon>
            <v-icon class="mobile-nav-icon">
              mdi-file-question
            </v-icon>
          </v-list-item-icon>

          <v-list-item-content>
            Quizzes
          </v-list-item-content>
        </v-list-item>

        <!-- Progress -->
        <v-list-item
          to="/progress"
          @click="closeDrawer"
        >
          <v-list-item-icon>
            <v-icon class="mobile-nav-icon">
              mdi-chart-line
            </v-icon>
          </v-list-item-icon>

          <v-list-item-content>
            Progress Tracker
          </v-list-item-content>
        </v-list-item>

        <!-- Goals -->
        <v-list-item
          to="/goals"
          @click="closeDrawer"
        >
          <v-list-item-icon>
            <v-icon class="mobile-nav-icon">
              mdi-target
            </v-icon>
          </v-list-item-icon>

          <v-list-item-content>
            Goals
          </v-list-item-content>
        </v-list-item>

        <!-- Planner -->
        <v-list-item
          to="/planner"
          @click="closeDrawer"
        >
          <v-list-item-icon>
            <v-icon class="mobile-nav-icon">
              mdi-calendar
            </v-icon>
          </v-list-item-icon>

          <v-list-item-content>
            Study Planner
          </v-list-item-content>
        </v-list-item>

      </v-list-group>

      <!-- Resources -->
      <v-list-item
        to="/resources"
        @click="closeDrawer"
        class="mobile-nav-item"
      >
        <v-list-item-icon>
          <v-icon class="mobile-nav-icon">
            mdi-link-variant
          </v-icon>
        </v-list-item-icon>

        <v-list-item-content
          style="
            font-family: 'Poppins', sans-serif;
            font-size: 16px;
          "
        >
          Resources
        </v-list-item-content>
      </v-list-item>

      <!-- Profile -->
      <v-list-item
        to="/profile"
        @click="closeDrawer"
        class="mobile-nav-item"
      >
        <v-list-item-icon>
          <v-icon class="mobile-nav-icon">
            mdi-account
          </v-icon>
        </v-list-item-icon>

        <v-list-item-content
          style="
            font-family: 'Poppins', sans-serif;
            font-size: 16px;
          "
        >
          Profile
        </v-list-item-content>
      </v-list-item>

      <!-- Register -->
      <v-list-item
        to="/register"
        @click="closeDrawer"
        class="mobile-nav-item"
      >
        <v-list-item-icon>
          <v-icon class="mobile-nav-icon">
            mdi-account-plus
          </v-icon>
        </v-list-item-icon>

        <v-list-item-content
          style="
            font-family: 'Poppins', sans-serif;
            font-size: 16px;
          "
        >
          Register
        </v-list-item-content>
      </v-list-item>

      <!-- Login -->
      <v-list-item
        v-if="!isAuthenticated"
        to="/login"
        @click="closeDrawer"
        class="mobile-nav-item"
      >
        <v-list-item-icon>
          <v-icon class="mobile-nav-icon">
            mdi-login
          </v-icon>
        </v-list-item-icon>

        <v-list-item-content
          style="
            font-family: 'Poppins', sans-serif;
            font-size: 16px;
          "
        >
          Login
        </v-list-item-content>
      </v-list-item>

      <!-- Logout -->
      <v-list-item
        v-if="isAuthenticated"
        @click="logoutAndCloseDrawer"
        class="mobile-nav-item mobile-logout-item"
      >
        <v-list-item-icon>
          <v-icon class="mobile-nav-icon">
            mdi-logout
          </v-icon>
        </v-list-item-icon>

        <v-list-item-content
          style="
            font-family: 'Poppins', sans-serif;
            font-size: 16px;
          "
        >
          Logout
        </v-list-item-content>
      </v-list-item>

    </v-list>
  </v-navigation-drawer>
</template>

<script>
import { mapGetters, mapActions } from "vuex";
import axios from "axios";

export default {
  name: "NavbarComponent",

  data() {
    return {
      drawer: false,
      tokenCheckInterval: null,
    };
  },

  computed: {
    ...mapGetters(["isAuthenticated"]),
  },

  methods: {
    ...mapActions(["logout"]),

    goToLanding() {
      this.$router.push("/");
    },

    closeDrawer() {
      this.drawer = false;
    },

    async logoutAndCloseDrawer() {
      this.closeDrawer();

      try {
        await this.logout();
      } catch (error) {
        console.error("Logout error:", error);
      }

      localStorage.removeItem("token");
      localStorage.removeItem("user");
      localStorage.removeItem("username");

      if (this.$route.path !== "/login") {
        this.$router.replace("/login");
      }
    },

    async fetchUserProfile() {
      const token = localStorage.getItem("token");

      /*
       * IMPORTANT:
       * Do not force logout simply because there is no token.
       * The Vuex authentication state may already be false.
       */
      if (!token) {
        return;
      }

      try {
        await axios.get(
          "https://studyspace-backend-delta.vercel.app/api/profile",
          {
            headers: {
              Authorization: `Bearer ${token}`,
            },
          }
        );

        console.log("StudySpace token validation successful.");
      } catch (error) {
        console.error(
          "Token validation failed:",
          error.response?.data?.message || error.message
        );

        /*
         * IMPORTANT:
         * Only remove the token when the backend explicitly
         * returns 401 Unauthorized.
         *
         * Do NOT logout for:
         * - 500 server errors
         * - network errors
         * - temporary Vercel errors
         * - connection failures
         */
        if (error.response?.status === 401) {
          this.forceLogout();
        }
      }
    },

    forceLogout() {
      console.log("Invalid or expired StudySpace token.");

      localStorage.removeItem("token");
      localStorage.removeItem("user");
      localStorage.removeItem("username");

      /*
       * Stop the old interval before logging out.
       */
      if (this.tokenCheckInterval) {
        clearInterval(this.tokenCheckInterval);
        this.tokenCheckInterval = null;
      }

      /*
       * Update Vuex authentication state.
       */
      try {
        this.logout();
      } catch (error) {
        console.error("Vuex logout error:", error);
      }

      /*
       * Redirect only from protected pages.
       */
      if (
        this.$route.path === "/home" ||
        this.$route.path === "/profile"
      ) {
        console.log("Redirecting to login...");
        this.$router.replace("/login");
      } else if (this.$route.path === "/login") {
        console.log("Already on login page.");
      } else {
        console.log(
          "User is not on /home or /profile. No redirect."
        );
      }
    },
  },

  created() {
    /*
     * Validate token once when Navbar is created.
     */
    this.fetchUserProfile();

    /*
     * Validate token periodically.
     */
    this.tokenCheckInterval = setInterval(
      this.fetchUserProfile,
      5000
    );
  },

  beforeUnmount() {
    /*
     * Prevent memory leaks.
     */
    if (this.tokenCheckInterval) {
      clearInterval(this.tokenCheckInterval);
      this.tokenCheckInterval = null;
    }
  },
};
</script>

<style scoped>
@import url("https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap");

.title:hover {
  color: #6200ea;
  cursor: pointer;
}

.title {
  font-weight: 700 !important;
}

.modern-navbar {
  border-bottom: 1px solid #e0e0e0 !important;
  padding: 8px 0 !important;
}

.v-app-bar {
  position: relative !important;
}

.logo-icon {
  font-size: 28px;
  color: #6366f1;
  margin-right: 12px;
}

.nav-btn {
  color: #1f2937 !important;
  font-weight: 500;
  text-transform: none;
  margin: 0 5px;
  padding: 8px 16px;
  font-family: "Poppins", sans-serif;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  border-radius: 12px;
}

.nav-icon {
  margin-right: 8px;
}

.nav-btn:hover {
  background: rgba(99, 102, 241, 0.08);
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(99, 102, 241, 0.12);
}

.active-link {
  background: rgba(99, 102, 241, 0.1) !important;
  box-shadow: 0 4px 12px rgba(99, 102, 241, 0.12);
}

.logout-btn,
.logout-btn .v-icon {
  color: #d32f2f !important;
}

.mobile-logout-item,
.mobile-logout-item .mobile-nav-icon,
.mobile-logout-item .v-list-item-content {
  color: #d32f2f !important;
}

.mobile-nav-item {
  display: flex;
  align-items: center;
  transition: background-color 0.3s ease;
}

.mobile-nav-item:hover {
  background-color: rgba(99, 102, 241, 0.08);
}

.mobile-nav-icon {
  margin-right: 10px;
  color: #333;
}

.v-navigation-drawer {
  border-radius: 0 8px 8px 0;
  box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.2);
}

.mobile-drawer-list {
  padding-top: 24px !important;
}

.v-list-item {
  transition: background-color 0.3s ease;
}

.v-list-item:hover {
  background-color: rgba(99, 102, 241, 0.08);
}

.main-content {
  margin-top: 64px;
  padding: 24px;
}

.mobile-menu-icon {
  color: #1f2937 !important;
  font-size: 26px;
}
</style>

